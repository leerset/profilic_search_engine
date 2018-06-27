class Mailer < ApplicationMailer
  # Rails.application.routes.default_url_options[:host] = Settings.host
  # Rails.application.routes.default_url_options[:host] = "http://dev.soloman.org.cn"
  Rails.application.routes.default_url_options[:host] = 'http://dedi2.cijef.com.hk'
  default from: Settings.mail_sender

  def add_prefix_and_suffix_to_subject(subject)
    # [Settings.mail_prefix, subject, Settings.mail_suffix].compact.join(" ")
    subject
  end

  def welcome_email(user)
    @user = user
    email = @user.email
    @subject = add_prefix_and_suffix_to_subject("Prolific Welcome")
    mail(to: email, subject: @subject)
  end

  def feedback_email(email, feedback, status)
    @feedback = feedback
    @status = status
    @subject = add_prefix_and_suffix_to_subject("Prolific Feedback")
    mail(to: email, subject: @subject)
  end

  def feedback_reply_email(email, feedback, status)
    @feedback = feedback
    @status = "Your mail was sent to Prolific, you'll get reply as soon as possible."
    @subject = add_prefix_and_suffix_to_subject("Prolific Feedback Reply")
    mail(to: email, subject: @subject)
  end

  def magic_link_email(user, status)
    @host = Settings.host
    @user = user
    @status = status
    @magic_link = user.magic_link
    @datetime = user.expires_at.strftime('%Y-%m-%d %H:%M')
    @subject = add_prefix_and_suffix_to_subject("Prolific Magic Link")
    mail(to: user.email, subject: @subject)
  end

  def add_invention_notification_email(user, invention, status = nil)
    @host = Settings.host
    @user = user
    @invention = invention
    @status = status
    @url = "inventions/#{invention.id}"
    @subject = add_prefix_and_suffix_to_subject("Prolific Add Invention Notification")
    mail(to: user.email, subject: @subject)
  end

  def review_invention_notification_email(user, invention, status = nil)
    @host = Settings.host
    @user = user
    @invention = invention
    @status = status
    @url = "inventions/#{invention.id}"
    @subject = add_prefix_and_suffix_to_subject("Prolific Review Invention Notification")
    mail(to: user.email, subject: @subject)
  end

  def verify_email(user)
    @user = user
    @token = generate_token
    email = @user.org_email

    $redis.del(email) if $redis.exists(email)
    $redis.set email, @token, ex: 60 * 30, nx: true
    @subject = "Prolific Email Verify"
    mail(to: email, subject: @subject)
  end

  private

  def generate_token
    token = ''
    loop do
      token =  rand(1000000)
      break if token > 100000
    end

    token
  end
end
