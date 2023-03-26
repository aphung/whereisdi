local defaults = {
    send = true,
    domain_invasion = {
        pos = {
            x = windower.get_windower_settings().ui_x_res / 4,
            y = windower.get_windower_settings().ui_y_res / 2 - 36
        },
        bg = {
            alpha = 255
        },
        text = {
            size = 11,
            font = 'Consolas',
            stroke = {
                width = 1,
                alpha = 200
            }
        },
        padding = 10,
        flags = {
            bold = true
        },
        show = false,
    },
}
return defaults