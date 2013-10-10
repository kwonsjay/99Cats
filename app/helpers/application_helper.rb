module ApplicationHelper

  def date_formatter(date)
    unless date.respond_to?(:strftime)
      date = DateTime.parse(date)
    end

    date.strftime("%B %e, %Y")
  end
end
