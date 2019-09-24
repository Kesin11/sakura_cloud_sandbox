module.exports = {
  platform: 'github',
  logFileLevel: 'warn',
  logLevel: 'info',
  logFile: '/tmp/renovate.log',
  onboarding: true,
  onboardingConfig: {
    extends: [
      'config:base',
      'config:semverAllMonthly',
      ':label(renovate)',
      ':prConcurrentLimit10',
      ':prNotPending',
      ':timezone(Asia/Tokyo)',
    ],
  },
  gitAuthor: "Renovate Bot <bot@renovateapp.com>",
  persistRepoData: true,
  repositories: ['Kesin11/sakura_cloud_sandbox', 'Kesin11/blog'],
};
