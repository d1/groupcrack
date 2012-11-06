# if create_group_setting is not loaded, add this seed data
seed_file = SeedFile.where(keyword: 'default_organization_roles').first
if seed_file.nil?    
  admin_org_role = OrganizationRole.create(name: "Admin", admin_role: 1)
  member_org_role = OrganizationRole.create(name: "Member")
  new_member_org_role = OrganizationRole.create(name: "New Member", sign_up_role: 1)

  SeedFile.create(keyword: 'default_organization_roles')
end
