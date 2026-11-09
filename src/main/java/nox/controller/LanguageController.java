package nox.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/language")
public class LanguageController {

    public static final String SESSION_ATTR = "lang";
    private static final String DEFAULT_LANG = "en";

    public static String currentLanguage(HttpSession session) {
        if (session == null) return DEFAULT_LANG;
        String lang = (String) session.getAttribute(SESSION_ATTR);
        return isValid(lang) ? lang : DEFAULT_LANG;
    }

    @GetMapping
    @ResponseBody
    public java.util.Map<String, String> getLanguage(HttpSession session) {
        java.util.Map<String, String> result = new java.util.LinkedHashMap<>();
        result.put("lang", currentLanguage(session));
        return result;
    }

    @PostMapping
    public String setLanguage(@RequestParam("lang") String lang,
                              @RequestParam(value = "next", defaultValue = "profile") String next,
                              HttpSession session) {
        if (isValid(lang)) {
            session.setAttribute(SESSION_ATTR, lang);
        }

        String safeNext = sanitizeRelativePath(next);
        return "redirect:/" + (safeNext != null ? safeNext : "profile");
    }

    private static boolean isValid(String lang) {
        return DEFAULT_LANG.equals(lang) || "my".equals(lang);
    }

    private String sanitizeRelativePath(String value) {
        if (value == null) return null;
        String trimmed = value.trim();
        if (trimmed.isEmpty()) return null;
        if (trimmed.startsWith("/") || trimmed.startsWith("\\")) return null;
        if (trimmed.contains("..") || trimmed.contains(":")) return null;
        if (!trimmed.matches("[a-zA-Z0-9_\\-./?#&=]+")) return null;
        return trimmed;
    }
}
