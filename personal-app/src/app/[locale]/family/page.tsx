import { useTranslations } from 'next-intl';

export default function FamilyPage() {
  const t = useTranslations();
  
  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <div className="bg-white shadow-sm border-b">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
          <div className="flex items-center justify-between">
            <h1 className="text-2xl font-bold text-gray-900">
              {t('family')}
            </h1>
            <button className="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition-colors">
              {t('add')}
            </button>
          </div>
        </div>
      </div>

      {/* Main Content */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {/* Family Members */}
          <div className="bg-white p-6 rounded-lg shadow-sm border">
            <h2 className="text-lg font-semibold text-gray-900 mb-4">
              {t('familyMembers')}
            </h2>
            <p className="text-gray-600">
              {t('noFamilyMembersYet')}
            </p>
          </div>

          {/* Shared Calendar */}
          <div className="bg-white p-6 rounded-lg shadow-sm border">
            <h2 className="text-lg font-semibold text-gray-900 mb-4">
              {t('sharedCalendar')}
            </h2>
            <p className="text-gray-600">
              {t('noSharedEvents')}
            </p>
          </div>

          {/* Family Activities */}
          <div className="bg-white p-6 rounded-lg shadow-sm border">
            <h2 className="text-lg font-semibold text-gray-900 mb-4">
              {t('familyActivities')}
            </h2>
            <p className="text-gray-600">
              {t('noActivities')}
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}
