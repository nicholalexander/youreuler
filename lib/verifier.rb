require 'open3'

class Verifier

  def initialize(message, keybase_username)
    @message = message
    @keybase_username = keybase_username
    @verified
  end

  def verify
    get_keys(@keybase_username)
    write_file(@message)
    result = run_gpg
    @verified = check_result(result)
  end

  def get_url
    extract_url(@message)
  end

  private

  def get_keys(keybase_username)
    system("curl https://keybase.io/#{keybase_username}/key.asc | gpg --import")
  end

  def write_file(message)
    File.open('temp.txt', 'w') { |file| file.write(message) }
  end

  def run_gpg
    out, err, st = Open3.capture3('gpg --verify temp.txt')
    err
  end

  def check_result(result)
    return true if result.include? ("Good signature from")
    false
  end

  def extract_url(message) 
    message.split("\n")[3]
  end

end
