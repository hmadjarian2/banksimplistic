class AccountDetailsReport < Report
  attribute :uid
  attribute :balance
  
  index :uid
  
  on :account_created do |event|
    create :uid => event.data[:uid], :balance => 0
  end
  
  on :deposite do |event|
    account = find(:uid => event.data[:account_uid])[0]
    account.balance = event.data[:new_balance].amount
    account.save
  end
end