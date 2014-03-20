class CourseUniqueCodeAssociation < ActiveRecord::Base
  belongs_to :course
  belongs_to :course_sections

  attr_accessible :course_id,:unique_access_code, :course_section_id

  # default key length: 10 characters
  mattr_accessor :unique_key_length
  self.unique_key_length = 10

  CHARSETS = {
      :alphanum => ('a'..'z').to_a + (0..9).to_a,
      :alphanumcase => ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a }

  # character set to chose from:
  #  :alphanum     - a-z0-9     -  has about 60 million possible combos
  #  :alphanumcase - a-zA-Z0-9  -  has about 900 million possible combos
  mattr_accessor :charset

  self.charset = :alphanum

  def key_chars
    CHARSETS[charset]
  end


  # we'll rely on the DB to make sure the unique key is really unique.
  # if it isn't unique, the unique index will catch this and raise an error
  def create
    count = 0
    begin
      self.unique_access_code = generate_unique_key
      super
        #ActiveRecord::RecordNotUnique
    rescue ActiveRecord::ActiveRecordError, ActiveRecord::StatementInvalid => err
      if (count +=1) < 5
        logger.info("retrying with different unique key")
        retry
      else
        logger.info("too many retries to get an unique code for the Reference, giving up")
        raise
      end
    end
  end

  # generate a random string
  # future mod to allow specifying a more expansive charst, like utf-8 chinese
  def generate_unique_key
    # not doing uppercase as url is case insensitive
    charset = key_chars
    (0...unique_key_length).map{ charset[rand(charset.size)] }.join
  end



end
