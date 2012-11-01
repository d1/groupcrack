# if create_group_setting is not loaded, add this seed data
seed_file = SeedFile.where(keyword: 'create_group_setting').first
if seed_file.nil?    
  create_group_setting = SettingType.create(name: "Create New Organizations", 
    description: "Ability to add new organizations to site",
    locked: 1,
    site_or_org_specific: 'site',
    user_specific: 1
    )
  create_group_setting.setting_values.create(name: "Yes", 
    position: 1,
    locked: 1,
    default_value: 1 )  
  create_group_setting.setting_values.create(name: "No", 
    position: 2,
    locked: 1)
  create_group_setting.setting_values.create(name: "Approval Required", 
    position: 3,
    locked: 1 )  

  SeedFile.create(keyword: 'create_group_setting')
end