return {
	LrSdkVersion = 3.0,

	LrToolkitIdentifier = 'ryancavanaugh.CollectionKeywords',
	LrPluginName = "Collections to Keywords",

	LrLibraryMenuItems = {
		title = 'Update Collection Keywords',
		file = 'UpdateCollections.lua',
		enabledWhen = 'photosAvailable'
	},

	VERSION = { major=5, minor=0, revision=0, build=907681, },
}
