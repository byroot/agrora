Fabricator(:group) do
  name "comp.lang.ruby"
  server do
    Fabricate.build(:server)
  end
end
