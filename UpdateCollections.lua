local LrApplication = import 'LrApplication'
local LrDialogs = import 'LrDialogs'
local LrTasks = import 'LrTasks'
local LrFunctionContext = import 'LrFunctionContext'
local catalog = LrApplication.activeCatalog()

function getOrCreateTopLevelKeyword()
	return catalog:createKeyword("[Collections]", {}, false, nil, true)
end

function createTopLevelKeyword()
	getOrCreateTopLevelKeyword()
end

function createNestedKeywords()
	local topLevel = catalog:createKeyword("[Collections]", {}, false, nil, true)

	-- Loop through each of the photos and collect all the collections they are in.
	for i,photo in ipairs(cat_photos) do
		-- For each keyword in the collections tag, clear it from this photo (in case it doesn't actually apply)
		for j, collectionKeyword in ipairs(topLevel:getChildren()) do
			photo:removeKeyword(collectionKeyword)
		end

		-- For each collection the photo is in, add a keyword for it
		collections = photo:getContainedCollections()
		for j, collection in ipairs(photo:getContainedCollections()) do
			catalog:createKeyword(collection:getName(), {}, true, topLevel, true)
		end
	end
end

function addKeywordsToPhotos()
	local topLevelKeywords = catalog:getKeywords()
	local collectionKeyword = nil
	for i, col in ipairs(topLevelKeywords) do
		if col:getName() == "[Collections]" then
			collectionKeyword = col
		end
	end

	for i,photo in ipairs(cat_photos) do
		for j, collection in ipairs(photo:getContainedCollections()) do
			for k, collectionKeyword in ipairs(collectionKeyword:getChildren()) do
				if(collectionKeyword:getName() == collection:getName()) then
					photo:addKeyword(collectionKeyword)
				end
			end
		end
	end
end

function updateCollectionKeywords()
	cat_photos = catalog.targetPhotos

	LrFunctionContext.postAsyncTaskWithContext('Update Collection Keywords', function(ctx)
		LrDialogs.attachErrorDialogToFunctionContext(ctx)
		-- Create top-level [Collections] keyword if needed
		catalog:withWriteAccessDo("Create top-level Collection keyword", createTopLevelKeyword)
		-- Create the next level of keywords
		catalog:withWriteAccessDo( "Create collection keywords", createNestedKeywords)
		-- Add keywords to photos
		catalog:withWriteAccessDo( "Create collection keywords", addKeywordsToPhotos)
	end)
end

updateCollectionKeywords()
