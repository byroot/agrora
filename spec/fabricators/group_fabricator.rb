Fabricator(:group) do
  name "comp.lang.ruby"
  server do
    Fabricate(:server)
  end
end
