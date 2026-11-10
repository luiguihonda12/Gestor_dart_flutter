# Aura - Gestor de Gastos Personales

Aplicación en **Dart & Flutter** para la gestión financiera personal basada en el sistema de diseño **Quiet Luxury Expense Architecture**.

---

## 🏛️ Vistas Principales

1. **Ingreso y Egreso (`screens/add_transaction_screen.dart`):**
   - Selector interactivo entre Gasto e Ingreso.
   - Display de cifra editorial con cursor pulsante.
   - Teclado numérico táctil de alta precisión integrado.
   - Selector horizontal de categorías con iconografía detallada.
   - Asignación de fecha, método de pago / bóveda y comprobante digital.

2. **Cronología y Vista por Día (`screens/daily_ledger_screen.dart`):**
   - Navegación cronológica por días (`<` y `>`) y selector con calendario.
   - Balance neto del día, total de ingresos (+) y egresos (-).
   - Filtros de movimientos (Todos, Gastos, Ingresos).
   - Lista minimalista con separación hairline, detalles y eliminación al deslizar.

3. **Gráficas y Análisis (`screens/analytics_screen.dart`):**
   - Píldoras de horizonte temporal (*Semana, Mes, Año*).
   - Síntesis ejecutiva (*Aura Synthesis*) con métricas de comportamiento.
   - Velocidad de consumo diario (*Burn Velocity*).
   - Gráfica Bezier personalizada (`VelocityTrajectoryChart`) del flujo de caja.
   - Barra segmentada de distribución proporcional de gastos por categoría.

4. **Ajustes y Preferencias (`screens/settings_screen.dart`):**
   - Tarjeta de perfil y bóveda de cliente.
   - Selector de moneda global (*USD, EUR, COP, MXN, GBP*).
   - Modo Oscuro Obsidiana / Modo Claro Papel Alabastro.
   - Recordatorio diario de balance.
   - Exportación de reporte y restablecimiento de datos.

---

## 🎨 Paleta de Diseño (Quiet Luxury)
- **Canvas / Fondo:** `#FAF9F7` (Alabastro cálido)
- **Tarjeta Elevada:** `#FFFFFF`
- **Tinta Primaria:** `#16171A` (Obsidiana)
- **Tinta Secundaria:** `#4A4D53` (Pizarra)
- **Líneas Estructurales:** `#E5E2DC` (Hairlines 1px)
- **Inflows (Ingresos):** `#2D4F3E` (Verde Ciprés)
- **Outflows (Gastos):** `#782E2E` (Vino Cordobés)

---

## 🚀 Ejecución
```bash
flutter pub get
flutter run
```

