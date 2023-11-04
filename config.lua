Config = {}

Config.Settings = {
    Permissions = false, -- if set to true only "allowed" user will be able to use the command
    Allowed = { -- users allowed to use commands
        'discord:123456789', -- your discord id -- https://support.discord.com/hc/en-us/articles/206346498-Where-can-I-find-my-User-Server-Message-ID-
        'discord:123456789', -- your discord id -- https://support.discord.com/hc/en-us/articles/206346498-Where-can-I-find-my-User-Server-Message-ID-
    },
}

Config.Shells = {
    PreviewLocation = vector3(226.49, -1023.46, -126.95),
	[1] = {
		name = 'shell_trailer',
        hight = 10, -- Preview Hight of the camera
	},
    [2] = {
        name = 'standardmotel_shell',
        hight = 10, -- Preview Hight of the camera
    },
    [3] = {
        name = 'furnitured_midapart',
        hight = 12, -- Preview Hight of the camera
    }
}