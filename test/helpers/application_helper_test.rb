require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
    test "formats page specific title" do 
        content_for(:title) { "page title" }

        assert_equal "page title | #{ I18n.t('mark-link')}", title
    end
    test "returns app name when page title is missing" do
        assert_equal I18n.t('mark-link'), title
    end
end