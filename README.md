# IronPulse 

IronPulse is a Java OOP-based Gym Membership Management System with a Swing dashboard UI.

## Features

- Dashboard cards include total members, active members, active plans, monthly revenue, today revenue, and pending payments
- Dashboard includes a recent activity panel (latest payments and member joins)
- Admin login before dashboard access (default: admin / ironpulse123)
- Login now uses a masked password field and max 3 attempts
- Member management: add, edit, deactivate, delete
- Member search filter (ID, name, contact, plan, status, type)
- Live search updates while typing in the member search box
- Safer table actions when sorting is enabled (edit/delete/export uses selected row correctly)
- Plan hierarchy: Student, Premium, VIP via abstract class polymorphism
- Billing service interface + implementation
- Payment tracking with PAID/PENDING status and receipt text
- Invoice export as text files in `invoices/` (auto on payment + manual export from table)
- Monthly summary export as text report in `reports/` from dashboard button
- CSV file persistence in `data/members.csv` and `data/payments.csv`
- Auto seed demo members/payments on first run when CSV files are empty
- Custom exceptions for member lookup and invalid payments
- Member validation and duplicate ID checks on add/update operations
- Form-level validation for age/date/amount fields with clear error messages

## OOP Mapping

- Encapsulation: private fields + getters/setters in model classes
- Inheritance: `MembershipPlan` base class with concrete plan subclasses
- Polymorphism: `calculateBilling()` overridden by each plan
- Abstraction: `BillingService` interface and `MembershipPlan` abstract class

## Run

From the `IronPluse` folder:

```bash
bash scripts/fetch_mongo_driver.sh
bash scripts/fetch_javafx.sh
mkdir -p out
javac --module-path "lib" --add-modules javafx.controls,javafx.graphics -cp "lib/*" -d out $(find src -name "*.java")
java --module-path "lib" --add-modules javafx.controls,javafx.graphics -cp "out:lib/*" ironpulse.Main
```

## Build JAR

To build a distributable JAR:

```bash
./build.sh --build-only
```

Generated artifact:

- `dist/IronPulse.jar`

Run from JAR:

```bash
java --module-path "lib" --add-modules javafx.controls,javafx.graphics -cp "lib/*:dist/IronPulse.jar" ironpulse.Main
```

## Build Windows EXE

EXE packaging must be done on Windows using jpackage.

1. Open Command Prompt in project root.
2. Run:

```bat
build_exe_windows.bat
```

Output:

- EXE installer is generated in dist/.

Important:

- Ensure JavaFX Windows jars are available in lib/ before packaging, for example:
	- javafx-base-21.0.5-win.jar
	- javafx-graphics-21.0.5-win.jar
	- javafx-controls-21.0.5-win.jar

To launch the Swing app inside the browser-backed viewer used in this workspace:

```bash
bash scripts/run_frontend.sh
```

The app now prefers JavaFX UI and automatically falls back to Swing if JavaFX cannot launch.

To run directly (desktop) with JavaFX dependencies prepared:

```bash
bash scripts/run_javafx.sh
```

Startup logs now show the active UI mode (`JavaFX` preferred, `Swing` fallback).

Then open:

```text
http://localhost:6080/vnc.html?autoconnect=true&resize=remote
```

## MongoDB Backend (Optional)

By default IronPulse uses CSV in `data/`. To use MongoDB instead, set environment variables before running:

```bash
export IRONPULSE_MONGO_URI="mongodb+srv://<user>:<pass>@<cluster-url>/?retryWrites=true&w=majority"
export IRONPULSE_MONGO_DB="ironpulse"
```

If MongoDB is unreachable, the app automatically falls back to CSV storage.

## Data Files

On first run, the app creates:

- `data/members.csv`
- `data/payments.csv`
