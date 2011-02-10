Fabricator(:server) do
  hostname "news.example.com"
  
  after_create do |server|
    server.groups.create(Fabricate.attributes_for(:group))
    server.groups.create(Fabricate.attributes_for(:group, :name => 'comp.lang.python'))
  end
end
