# if create_group_setting is not loaded, add this seed data
seed_file = SeedFile.where(keyword: 'site_administrator').first
if seed_file.nil?    
  create_group_setting = SettingType.create(name: "Site Administrator", 
    description: "Ability to manage entire site",
    locked: 1,
    site_or_org_specific: 'site',
    user_specific: 1
    )
  create_group_setting.setting_values.create(name: "Yes", 
    position: 1,
    locked: 1 )  
  create_group_setting.setting_values.create(name: "No", 
    position: 2,
    locked: 1,
    default_value: 1 )

  SeedFile.create(keyword: 'site_administrator')
end
