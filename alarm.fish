function alarm
    set numeric_input_re '^[0-9]+$'
    set time_input_re '^\d{2}:\d{2}$'
    set alert_in_seconds 'undefined'
    set err  'wrong input format, please use HH:MM (eg. 09:30) or number of minutes (eg. 30)'
    set err2 'max values are 23:59 or use number of minutes'
    set err3 'alarm in the past!'
    set raw_alert_time_input $argv[1]

    echo "alarm clock input: $raw_alert_time_input"

    if test (string match -r $numeric_input_re $raw_alert_time_input)
        set alert_in_seconds (math $raw_alert_time_input "*" 60)

        if test $raw_alert_time_input -gt 59
            set hr (math $raw_alert_time_input / 60)
            set min (math $raw_alert_time_input "%" 60)
            echo "alarm in $hr hour and $min minutes"
        else
            echo "alarm in $raw_alert_time_input minutes"
        end
    end

	if test (string match -r $time_input_re $raw_alert_time_input)
        set alert_hr_min_input (string split : $raw_alert_time_input)
        set alert_hr $alert_hr_min_input[1]
        set alert_min $alert_hr_min_input[2]

        if test $alert_hr -gt 23; or test $alert_min -gt 59
            set err $err2
        else
            set alert_seconds_1970 (date -d "$raw_alert_time_input" "+%s")
            set now_seconds_1970 (date "+%s")
            set now_vs_alert_seconds_dif (math $alert_seconds_1970 - $now_seconds_1970)

            if test $now_vs_alert_seconds_dif -gt 0
                set alert_in_seconds $now_vs_alert_seconds_dif
                echo "alarm in" (math $alert_in_seconds "/" 60) "minutes"

            else
                set err $err3
            end
        end
    end

    if test (string match "$alert_in_seconds" "undefined")
        echo $err
    else
        sleep "$alert_in_seconds"s
        # eog = usuall default image viewer + path to image to pop up
        eog ~/Pictures/plant-leaves-dark.jpg
    end
end
