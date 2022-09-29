# frozen_string_literal: true

require 'modules/slugger'

rubric_category = RubricCategory.find_by(slug: slug_em('Repository Info'))
if rubric_category.nil?
  rubric_category = RubricCategory.new(
    name: 'Repository Info',
    slug: slug_em('Repository Info'),
    weight: 1
  )
  rubric_category.save
end

releases_indicator = CategoryIndicator.find_by(slug: slug_em('Releases'))
if releases_indicator.nil?
  releases_indicator = CategoryIndicator.new(
    name: 'Releases',
    slug: slug_em('Releases'),
    indicator_type: 'scale',
    weight: 0.1,
    rubric_category_id: rubric_category.id,
    data_source: 'GitHub',
    source_indicator: 'releases'
  )
  if releases_indicator.save
    indicator_desc = CategoryIndicatorDescription.find_by(category_indicator_id: releases_indicator.id, locale: 'en')
    indicator_desc = CategoryIndicatorDescription.new if indicator_desc.nil?
    indicator_desc.description = 'Number of releases in the past year.'
    indicator_desc.category_indicator_id = releases_indicator.id
    indicator_desc.locale = 'en'
    indicator_desc.save
  end
end

downloads_indicator = CategoryIndicator.find_by(slug: slug_em('Downloads'))
if downloads_indicator.nil?
  downloads_indicator = CategoryIndicator.new(
    name: 'Downloads',
    slug: slug_em('Downloads'),
    indicator_type: 'scale',
    weight: 0.1,
    rubric_category_id: rubric_category.id,
    data_source: 'GitHub',
    source_indicator: 'downloadCount'
  )
  if downloads_indicator.save
    indicator_desc = CategoryIndicatorDescription.find_by(category_indicator_id: downloads_indicator.id, locale: 'en')
    indicator_desc = CategoryIndicatorDescription.new if indicator_desc.nil?
    indicator_desc.description = 'Number of times cloned in the last 14 days.'
    indicator_desc.category_indicator_id = downloads_indicator.id
    indicator_desc.locale = 'en'
    indicator_desc.save
  end
end

forks_indicator = CategoryIndicator.find_by(slug: slug_em('Forks'))
if forks_indicator.nil?
  forks_indicator = CategoryIndicator.new(
    name: 'Forks',
    slug: slug_em('Forks'),
    indicator_type: 'scale',
    weight: 0.1,
    rubric_category_id: rubric_category.id,
    data_source: 'GitHub',
    source_indicator: 'forkCount'
  )
  if forks_indicator.save
    indicator_desc = CategoryIndicatorDescription.find_by(category_indicator_id: forks_indicator.id, locale: 'en')
    indicator_desc = CategoryIndicatorDescription.new if indicator_desc.nil?
    indicator_desc.description = 'Number of forks.'
    indicator_desc.category_indicator_id = forks_indicator.id
    indicator_desc.locale = 'en'
    indicator_desc.save
  end
end

stars_indicator = CategoryIndicator.find_by(slug: slug_em('Stars'))
if stars_indicator.nil?
  stars_indicator = CategoryIndicator.new(
    name: 'Stars',
    slug: slug_em('Stars'),
    indicator_type: 'scale',
    weight: 0.1,
    rubric_category_id: rubric_category.id,
    data_source: 'GitHub',
    source_indicator: 'stargazers'
  )
  if stars_indicator.save
    indicator_desc = CategoryIndicatorDescription.find_by(category_indicator_id: stars_indicator.id, locale: 'en')
    indicator_desc = CategoryIndicatorDescription.new if indicator_desc.nil?
    indicator_desc.description = 'Number of stars.'
    indicator_desc.category_indicator_id = stars_indicator.id
    indicator_desc.locale = 'en'
    indicator_desc.save
  end
end

open_pr_indicator = CategoryIndicator.find_by(slug: slug_em('Open Pull Requests'))
if open_pr_indicator.nil?
  open_pr_indicator = CategoryIndicator.new(
    name: 'Open Pull Requests',
    slug: slug_em('Open Pull Requests'),
    indicator_type: 'scale',
    weight: 0.1,
    rubric_category_id: rubric_category.id,
    data_source: 'GitHub',
    source_indicator: 'openPullRequestCount'
  )
  if open_pr_indicator.save
    indicator_desc = CategoryIndicatorDescription.find_by(category_indicator_id: open_pr_indicator.id, locale: 'en')
    indicator_desc = CategoryIndicatorDescription.new if indicator_desc.nil?
    indicator_desc.description = 'Number of open pull requests.'
    indicator_desc.category_indicator_id = open_pr_indicator.id
    indicator_desc.locale = 'en'
    indicator_desc.save
  end
end

merged_pr_indicator = CategoryIndicator.find_by(slug: slug_em('Merged Pull Requests'))
if merged_pr_indicator.nil?
  merged_pr_indicator = CategoryIndicator.new(
    name: 'Merged Pull Requests',
    slug: slug_em('Merged Pull Requests'),
    indicator_type: 'scale',
    weight: 0.1,
    rubric_category_id: rubric_category.id,
    data_source: 'GitHub',
    source_indicator: 'mergedPullRequestCount'
  )
  if merged_pr_indicator.save
    indicator_desc = CategoryIndicatorDescription.find_by(category_indicator_id: merged_pr_indicator.id, locale: 'en')
    indicator_desc = CategoryIndicatorDescription.new if indicator_desc.nil?
    indicator_desc.description = 'Number of merged pull requests.'
    indicator_desc.category_indicator_id = merged_pr_indicator.id
    indicator_desc.locale = 'en'
    indicator_desc.save
  end
end

open_issues_indicator = CategoryIndicator.find_by(slug: slug_em('Open Issues'))
if open_issues_indicator.nil?
  open_issues_indicator = CategoryIndicator.new(
    name: 'Open Issues',
    slug: slug_em('Open Issues'),
    indicator_type: 'scale',
    weight: 0.1,
    rubric_category_id: rubric_category.id,
    data_source: 'GitHub',
    source_indicator: 'openIssues'
  )
  if open_issues_indicator.save
    indicator_desc = CategoryIndicatorDescription.find_by(category_indicator_id: open_issues_indicator.id, locale: 'en')
    indicator_desc = CategoryIndicatorDescription.new if indicator_desc.nil?
    indicator_desc.description = 'Number of opened issues.'
    indicator_desc.category_indicator_id = open_issues_indicator.id
    indicator_desc.locale = 'en'
    indicator_desc.save
  end
end

closed_issues_indicator = CategoryIndicator.find_by(slug: slug_em('Closed Issues'))
if closed_issues_indicator.nil?
  closed_issues_indicator = CategoryIndicator.new(
    name: 'Closed Issues',
    slug: slug_em('Closed Issues'),
    indicator_type: 'scale',
    weight: 0.1,
    rubric_category_id: rubric_category.id,
    data_source: 'GitHub',
    source_indicator: 'closedIssues'
  )
  if closed_issues_indicator.save
    indicator_desc = CategoryIndicatorDescription.find_by(category_indicator_id: closed_issues_indicator.id,
                                                          locale: 'en')
    indicator_desc = CategoryIndicatorDescription.new if indicator_desc.nil?
    indicator_desc.description = 'Number of closed issues.'
    indicator_desc.category_indicator_id = closed_issues_indicator.id
    indicator_desc.locale = 'en'
    indicator_desc.save
  end
end

last_repo_activity_indicator = CategoryIndicator.find_by(slug: slug_em('Last Repository Activity'))
if last_repo_activity_indicator.nil?
  last_repo_activity_indicator = CategoryIndicator.new(
    name: 'Last Repository Activity',
    slug: slug_em('Last Repository Activity'),
    indicator_type: 'scale',
    weight: 0.1,
    rubric_category_id: rubric_category.id,
    data_source: 'GitHub',
    source_indicator: 'updatedAt'
  )
  if last_repo_activity_indicator.save
    indicator_desc = CategoryIndicatorDescription.find_by(category_indicator_id: last_repo_activity_indicator.id,
                                                          locale: 'en')
    indicator_desc = CategoryIndicatorDescription.new if indicator_desc.nil?
    indicator_desc.description = 'Last repository activity date.'
    indicator_desc.category_indicator_id = last_repo_activity_indicator.id
    indicator_desc.locale = 'en'
    indicator_desc.save
  end
end

commits_indicator = CategoryIndicator.find_by(slug: slug_em('Commits'))
if commits_indicator.nil?
  commits_indicator = CategoryIndicator.new(
    name: 'Commits',
    slug: slug_em('Commits'),
    indicator_type: 'scale',
    weight: 0.1,
    rubric_category_id: rubric_category.id,
    data_source: 'GitHub',
    source_indicator: 'commitsOnMasterBranch, commitsOnMainBranch'
  )
  if commits_indicator.save
    indicator_desc = CategoryIndicatorDescription.find_by(category_indicator_id: commits_indicator.id, locale: 'en')
    indicator_desc = CategoryIndicatorDescription.new if indicator_desc.nil?
    indicator_desc.description = 'Number of commits on master or main branch.'
    indicator_desc.category_indicator_id = commits_indicator.id
    indicator_desc.locale = 'en'
    indicator_desc.save
  end
end
