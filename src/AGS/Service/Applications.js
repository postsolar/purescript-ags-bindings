const A = await Service.import('applications')

export const bindApplications =
  prop => () =>
    A.bind(prop)

export const list =
  () =>
    A.list

export const query =
  s => () =>
    A.query(s)

export const launchApp =
  app => () =>
    app.launch()

export const matchAppName =
  q => app => () =>
    app.match(q)

export const reloadDesktopInfo =
  app => () =>
    app.reload()

