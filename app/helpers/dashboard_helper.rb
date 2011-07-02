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
        I18n.t(sym, scope) + format_datetime(date, :past => false)
      else
        if significant
          sym = :past_sig
        elsif friend
          sym = :past_friend
        else
          sym = :past
        end
        I18n.t(sym, scope) + format_datetime(date, :past => true)
      end
    else
      link_to I18n.t(:no_date_set, scope) #Choose where they need to go to set the date
    end
  end


end
