enum PlanFilterCriteria {
  all,
  my,
  ongoing,
  downloaded,
}

Map<PlanFilterCriteria, String> planFilterCriteriaChipNames = {
  PlanFilterCriteria.all: 'All plans',
  PlanFilterCriteria.my: 'My plans',
  PlanFilterCriteria.ongoing: 'Ongoing',
  PlanFilterCriteria.downloaded: 'Downloaded',
};

Map<PlanFilterCriteria, String> planFilterCriteriaTitleNames = {
  PlanFilterCriteria.all: 'All plans',
  PlanFilterCriteria.my: 'Plans created by me',
  PlanFilterCriteria.ongoing: 'Ongoing plans',
  PlanFilterCriteria.downloaded: 'Plans created by other users',
};
