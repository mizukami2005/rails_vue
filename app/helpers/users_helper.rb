module UsersHelper
  include SessionsHelper

  def gravatar_for(user, options = { size: 80})
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  def show_follow?(session, user)
    if current_user.present?
      session.present? && session.include?(user.id) || current_user.following?(user)
    else
      session.present? && session.include?(user.id)
    end
  end

  def sum_count(session, following)
    (session.to_a + following.to_a).uniq.count
  end
end
