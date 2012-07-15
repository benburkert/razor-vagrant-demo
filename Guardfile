# Guardfile for watching a local Razor source directory and calling Rake tasks to sync into [gold] VM on changes
# Place your Razor git clone into src/Razor

notification :growl_notify, :sticky => true, :priority => 0

guard 'rake', :task => 'src_spec' do
  watch(%r{^src/Razor/spec/.+\.(rb|js|yaml|json)$})
end

guard 'rake', :task => 'src_bin' do
  watch(%r{^src/Razor/bin/.+\.(rb|js|yaml|json)$})
end

guard 'rake', :task => 'src_lib' do
  watch(%r{^src/Razor/lib/.+\.(rb|js|yaml|json)$})
end
