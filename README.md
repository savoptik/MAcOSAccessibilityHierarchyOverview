#  Приложение для диагностики a11y в приложениях MacOS

Это приложение позволяет увидить иерархию объектов доступности в указанном окне MacOS.

Справка по командам:

* -l --list — Список окон
* -g  --getHierarchy — Получить иерархию a11y объектов для PID окна
* -f  -f --front — Получить иерархию для текущего активного окна
* -h  --help — справка

---

# Application for diagnostics of a11y in macOS applications

This app allows you to see the hierarchy of accessibility objects in a specified macOS window.

Command reference:

* -l --list - List windows
* -g --getHierarchy - Get a11y object hierarchy for the window PID
* -f -f --front - Get the hierarchy for the currently active window
* -h --help - help


--

## Примеры запуска:
## Launch examples:

```Bash
    $ ./AccessibilityTool -l
    $ ./AccessibilityTool -g <pid>
    $ ./AccessibilityTool -g <pid> [<depth>]
```

### Полные имена команд:
### Full command names:

```Bash
    $ ./AccessibilityTool --list
    $ ./AccessibilityTool --getHierarchy <pid>
    $ ./AccessibilityTool --getHierarchy <pid> [<depth>]
```

---

## Внимание
При первом запуске приложение может выдать ошибку, необходимо разрешить утилите использование инструментов универсального доступа.

---

## Attention
When the application is launched for the first time, it may give an error, you need to allow the utility to use the accessibility tools.