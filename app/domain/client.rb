class Client
  include AggregateRoot
  
  def initialize
    @account_uids = []
  end
  
  def self.create(attributes)
    client = self.new
    client.apply_event :client_created, attributes.merge(:uid => new_uid)
    client
  end
  
  def open_account(attributes)
    self.should_exist
    
    account = Account.create(attributes.merge(:client_uid => uid))
    apply_event :account_assigned_to_client, :account_uid => account.uid
    account
  end
  
  def assign_new_card_for_account(account_uid)
    self.should_exist
    self.should_own_account account_uid

    apply_event :new_card_assigned, :client_uid  => uid,
                                    :account_uid => account_uid,
                                    :card_number => generate_new_card_number
  end
  
  protected
  
  def generate_new_card_number
    4.times.map{ 4.times.map { rand(9) }.join }.join(" ") 
  end
  
  def owns_account?(account_uid)
    @account_uids.include? account_uid
  end
  
  def on_client_created(event)
    @uid = event.data[:uid]
  end
  
  def on_account_assigned_to_client(event)
    @account_uids << event.data[:account_uid]
  end
  
  def on_new_card_assigned(event)
    # no need to change state
  end

end