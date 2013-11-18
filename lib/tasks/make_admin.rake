# CR_Priyank: Description for every rake task is must
namespace :users do
  task :make_admin => :environment do
    puts "Input email for admin"
    email = STDIN.gets.chomp
    user = User.find_by(email: email)
    if !(user.nil?)
      user.is_admin = true 
      user.save!
    end
  end    
end