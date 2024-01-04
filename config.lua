Config = {}
Config.debug = false

Config.Settings = {
    Command = "shells",
    Permissions = false, -- if set to true only "allowed" user will be able to use the command
    Allowed = { -- users allowed to use commands
        'discord:123456789', -- your discord id -- https://support.discord.com/hc/en-us/articles/206346498-Where-can-I-find-my-User-Server-Message-ID-
        'discord:123456789', -- your discord id -- https://support.discord.com/hc/en-us/articles/206346498-Where-can-I-find-my-User-Server-Message-ID-
    },
    PreviewLocation = vector3(226.49, -1023.46, -126.95),
}

Config.Shells = {
	{
		name = 'classichouse_shell',
        hight = 10, -- Preview Hight of the camera
        url = 'https://cdn.discordapp.com/attachments/1133534812704079964/1192608681934717050/image.png?ex=65a9b263&is=65973d63&hm=2fde5672a95628bd339e6e838972293980905b2f207ccd501a91e3cd5951b544&',
        inside = vec3(230.91, -1025.33, -121.68)
	},
}