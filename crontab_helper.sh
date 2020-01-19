#!/bin/bash

SUCCESS=0
ERROR=1

let exit_code=${SUCCESS}

this_uid=$(id -un 2> /dev/null)
system_update_script="/usr/local/sbin/system_update.sh"

if [ "${this_uid}" = "root" ]; then
    let crontab_exists=$(crontab -l 2> /dev/null | egrep -c "${system_update_script}")

    if [ ${crontab_exists} -eq 0 -a -x "${system_update_script}" ]; then
        old_crontab=$(crontab -l 2> /dev/null)

        while [ "${this_hour}" = "" ]; do
            clear
            echo "Creating crontab entry for '${system_update_script}'"
            echo "Valid hours of the day are 0 (midnight) to 23 (eleven PM)"
            read -p "Enter the hour of the day you would like to run 'system_update.sh' " this_hour
            this_hour=$(echo "${this_hour}" | sed -e 's|[^0-9]||g')
        
            let status_code=$(echo "0<=${this_hour}" | bc 2> /dev/null)
            let status_code+=$(echo "${this_hour}<=23" | bc 2> /dev/null)
        
            if [ ${status_code} -lt 2 ]; then
                this_hour=""
                echo "Invalid hour of the day"
                sleep 3
            else
                let hour=${this_hour}
            fi
        
        done

        while [ "${this_minute}" = "" ]; do
            clear
            echo "Creating crontab entry for '${system_update_script}'"
            echo "Valid minutes of the day are 0 (on the hour) to 59 minutes past the hour"
            read -p "Enter the minute of the day you would like to run 'system_update.sh' " this_minute
            this_minute=$(echo "${this_minute}" | sed -e 's|[^0-9]||g')
        
            let status_code=$(echo "0<=${this_minute}" | bc 2> /dev/null)
            let status_code+=$(echo "${this_minute}<=59" | bc 2> /dev/null)
        
            if [ ${status_code} -lt 2 ]; then
                this_minute=""
                echo "Invalid minute of the day"
                sleep 3
            else
                let minute=${this_minute}
            fi
        
        done

        while [ "${this_weekday}" = "" ]; do
            clear
            echo "Creating crontab entry for '${system_update_script}'"
            echo "Valid values for weekday are 0 (Sunday) through 6 (Saturday).  You can also use 7 for Sunday"
            read -p "Enter the day of the week you would like to run 'system_update.sh' " this_weekday
            this_weekday=$(echo "${this_weekday}" | sed -e 's|[^0-9]||g')
        
            let status_code=$(echo "0<=${this_weekday}" | bc 2> /dev/null)
            let status_code+=$(echo "${this_weekday}<=7" | bc 2> /dev/null)
        
            if [ ${status_code} -lt 2 ]; then
                this_weekday=""
                echo "Invalid weekday value"
                sleep 3
            else
                let weekday=${this_weekday}
            fi
        
        done

        crontab_temp_file="${/tmp/${USER}.crontab.$$}"
        echo "${old_crontab}"          > "${crontab_temp_file}"
        echo "#"                      >> "${crontab_temp_file}"
        echo "# Run system_update.sh" >> "${crontab_temp_file}"
        echo "${minute} ${hour} * * ${weekday} ( ${system_update_script} 2>&1 | logger -t \"Automated System Updates\" )" >> "${crontab_temp_file}"

        if [ -s "${crontab_temp_file}" ]; then
            crontab "${crontab_temp_file}"
            let exit_code=${?}

            if [ ${exit_code} -ne ${SUCCESS} ]; then
                echo "  Failed to update crontab"
            fi

            rm "${crontab_temp_file}" > /dev/null 2>&1
        fi

    else
        echo "  Make sure there is no existing crontab referencing 'system_update.sh' and that '${system_update_script}' is executable"
        let exit_code=${ERROR}
    fi

else
    echo "  This script must be run by root.  Try again with sudo"
    let exit_code=${ERROR}
fi

if [ ${exit_code} -eq ${SUCCESS} ]; then
    echo "SUCCESS"
fi

exit ${exit_code}
