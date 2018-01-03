class Mailer < ApplicationMailer
  # Rails.application.routes.default_url_options[:host] = Settings.host
  # Rails.application.routes.default_url_options[:host] = "http://dev.soloman.org.cn"
  Rails.application.routes.default_url_options[:host] = 'http://dedi2.cijef.com.hk'
  # default from: 'jianyi.prolific@gmail.com'
  default from: 'order@soloman.co'
  # default from: 'jianyi@hydrap.com'
  # default cc: 'jianyi@hydrap.com'
  # default cc: 'jianyi.prolific@gmail.com'
  # layout 'mailer/order_email'
  # layout 'mailer/welcome_email'

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

  def magic_link_email(email, magic_link, status)
    @magic_link = magic_link
    @status = status
    @subject = add_prefix_and_suffix_to_subject("Prolific Magic Link")
    mail(to: email, subject: @subject)
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
