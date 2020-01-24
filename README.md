#  Приложение для диагностики a11y в приложениях MacOS

Это приложение позволяет увидить иерархию объектов доступности в указанном окне MacOS.

Справка по командам:

* -l --list — Список окон
* -g  --getHierarchy — Получить иерархию a11y объектов для PID окна
* -h  --help — справка

Примеры запуска:
```Bash
    $ ./AccessibilityTool -l
    $ ./AccessibilityTool -g <pid>
    $ ./AccessibilityTool -g <pid> [<depth>]
```

Полные имена команд:

```Bash
    $ ./AccessibilityTool --list
    $ ./AccessibilityTool --getHierarchy <pid>
    $ ./AccessibilityTool --getHierarchy <pid> [<depth>]
```

