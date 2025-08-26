import { useTranslations } from 'next-intl';

export default function LocaleHomePage() {
  const t = useTranslations();
  
  return (
    <div className="min-h-screen bg-white">
      <div className="max-w-7xl mx-auto py-12 px-4 sm:px-6 lg:px-8">
        <div className="text-center">
          <h1 className="text-4xl font-bold text-gray-900 mb-4">
            {t('appTitle')}
          </h1>
          <p className="text-xl text-gray-600 mb-8">
            {t('playtimeDescription')}
          </p>
          
          <div className="space-y-4">
            <div className="bg-blue-50 p-4 rounded-lg">
              <h2 className="text-lg font-semibold text-blue-900">
                {t('playtimeCreate')}
              </h2>
            </div>
            
            <div className="bg-green-50 p-4 rounded-lg">
              <h2 className="text-lg font-semibold text-green-900">
                {t('home')}
              </h2>
            </div>
            
            <div className="bg-purple-50 p-4 rounded-lg">
              <h2 className="text-lg font-semibold text-purple-900">
                {t('participants')}
              </h2>
            </div>
          </div>
          
          <div className="mt-8 space-y-4">
            <div className="bg-yellow-50 p-4 rounded-lg">
              <h3 className="text-md font-semibold text-yellow-900">
                {t('playtimeLandingChooseMode')}
              </h3>
              <div className="mt-2 space-x-4">
                <span className="inline-block bg-white px-3 py-1 rounded border">
                  {t('playtimeModeLive')}
                </span>
                <span className="inline-block bg-white px-3 py-1 rounded border">
                  {t('playtimeModeVirtual')}
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
