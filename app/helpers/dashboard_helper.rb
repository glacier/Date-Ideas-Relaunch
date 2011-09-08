module DashboardHelper
  def format_date_header date, significant = false, friend = false
    scope = {:scope => [:dashboard, :datecart]}
    if date
      if date > DateTime.now
        if significant
          sym = :upcoming_sig
        elsif friend
          sym = :upcoming_friend
        else
          sym = :upcoming
        end
        # I18n.t(sym, scope) + format_datetime(date, :past => false)
        format_datetime(date, :past => false)
      else
        if significant
          sym = :past_sig
        elsif friend
          sym = :past_friend
        else
          sym = :past
        end
        # I18n.t(sym, scope) + format_datetime(date, :past => true)
        format_datetime(date, :past => true)
      end
    else
      #Choose where they need to go to set the date
      # link_to I18n.t(:no_date_set, scope)
      # Removed the link_to as it throws a "no route matches {}" error
      I18n.t(:no_date_set, scope)
    end
  end
end
