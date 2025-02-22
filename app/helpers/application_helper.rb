module ApplicationHelper
    def title
        return t("mark-link") unless content_for(:title)

        "#{content_for(:title)} | #{t("mark-link")}"
    end
end
