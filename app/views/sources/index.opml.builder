xml.instruct!
xml.opml(version: "1.0") do
	xml.head do
		xml.title "Prophet feeds"
	end
	xml.body do
		for t in Tag.all
			xml.outline(text: t.name, type: "tag") do
				for s in t.sources
					xml.outline(title: s.name, text: s.name, type: "rss", xmlUrl: s.url, htmlUrl: s.html_url)
				end
			end
		end
	end
end
