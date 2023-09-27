module ReadPlaybookFiles
  class AnsibleDataGenerator < Jekyll::Generator
    def self.playbooks_root
        'playbooks'
    end

    def roles_root
        'playbooks/roles'
    end

    def self.playbook_path(path)
        "#{playbooks_root}#{path}"
    end

    def role_path(path)
    end

    def generate(site)
      site.pages.each do |doc|
        puts "WAA"
        meta_file = self.class.playbook_path("#{doc.path}.yml")
        if File.exist?(meta_file)
            meta_data = SafeYAML.load_file(meta_file)
            doc.data['ansible'] = meta_data
            puts self.playbook_path("da")
            puts doc.data.inspect
        end
      end

    end
  end
end