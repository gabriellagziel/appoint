# Page snapshot

```yaml
- generic [active] [ref=e1]:
  - main [ref=e2]:
    - heading "Create a Meeting" [level=1] [ref=e3]
    - generic [ref=e4]:
      - generic [ref=e5]: What kind of meeting do you want to create?
      - generic [ref=e6]:
        - button "👤 Personal 1:1" [ref=e7] [cursor=pointer]
        - button "👥 Group / Event" [ref=e8] [cursor=pointer]
        - button "💻 Virtual" [ref=e9] [cursor=pointer]
        - button "🏢 With a Business" [ref=e10] [cursor=pointer]
        - button "🎮 Playtime" [ref=e11] [cursor=pointer]
        - button "📢 Open Call" [ref=e12] [cursor=pointer]
  - navigation [ref=e13]:
    - list [ref=e14]:
      - listitem [ref=e15]:
        - link "Home" [ref=e16] [cursor=pointer]:
          - /url: /en/home
      - listitem [ref=e17]:
        - link "Meetings" [ref=e18] [cursor=pointer]:
          - /url: /en/meetings
      - listitem [ref=e19]:
        - link "Reminders" [ref=e20] [cursor=pointer]:
          - /url: /en/reminders
      - listitem [ref=e21]:
        - link "Groups" [ref=e22] [cursor=pointer]:
          - /url: /en/groups
      - listitem [ref=e23]:
        - link "Family" [ref=e24] [cursor=pointer]:
          - /url: /en/family
      - listitem [ref=e25]:
        - link "Settings" [ref=e26] [cursor=pointer]:
          - /url: /en/settings
```