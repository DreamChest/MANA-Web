module ApplicationHelper

	# Translates a string has a label
	def l(l, options = {})
		t("label", label: t(l, count: options[:count] || 1))
	end
end
