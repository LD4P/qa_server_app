# Controller for Authorities header menu item
class AuthorityListController < AuthorityValidationController

  class_attribute :presenter_class
  self.presenter_class = AuthorityListPresenter

  # Sets up presenter with data to display in the UI
  def index
    list(authorities_list)
    @presenter = presenter_class.new(urls_data: status_data_from_log)
  end
end
