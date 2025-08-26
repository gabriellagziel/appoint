"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";

export default function LocaleDetector() {
  const router = useRouter();
  const [detected, setDetected] = useState(false);

  useEffect(() => {
    if (detected) return;
    
    // Detect user language
    const userLang = navigator.language || navigator.languages?.[0] || "en";
    const userCountry = Intl.DateTimeFormat().resolvedOptions().locale.split("-")[1];
    
    let targetLocale = "en";
    
    if (userLang.startsWith("it") || userCountry === "IT") {
      targetLocale = "it";
    } else if (userLang.startsWith("he") || userCountry === "IL") {
      targetLocale = "he";
    }
    
    // Redirect to appropriate locale if not already there
    const currentPath = window.location.pathname;
    if (!currentPath.startsWith(\`/\${targetLocale}\`) && targetLocale !== "en") {
      const newPath = \`/\${targetLocale}\${currentPath === "/" ? "" : currentPath}\`;
      router.push(newPath);
    }
    
    setDetected(true);
  }, [router, detected]);

  return null; // Invisible component
}
