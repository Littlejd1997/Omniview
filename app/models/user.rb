class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :periscopes, foreign_key: :twitterhandle, primary_key: :twitterhandle
  before_save { |user|
    begin
      user.twitterhandle= user.twitterhandle.downcase
    rescue
    end
  }
  before_save :startTasks
  before_save :twitterName

  def startTasks
    FetchPeriscopes.perform_later(self.twitterhandle)
  end

  def twitterName
    begin
      twitterInfo = $twitter.user(twitterhandle);
      names = twitterInfo.name.partition(" ");
      self.firstname = names.first
      self.lastname = names.last
      self.bio = twitterInfo.description;
    rescue (e)
      puts e;
    end

  end

  def to_param
    twitterhandle
  end
end
