module CatsHelper
  def sex_checked(value,sex)
     "checked".html_safe if value == sex
  end

  def color_selected(value,color)
     "selected".html_safe if value == color
  end
end
