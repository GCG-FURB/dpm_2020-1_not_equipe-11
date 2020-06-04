import 'package:charts_flutter/flutter.dart';

class DateTimeAxisSpecWorkaround extends DateTimeAxisSpec {

  const DateTimeAxisSpecWorkaround ({
    RenderSpec<DateTime> renderSpec,
    DateTimeTickProviderSpec tickProviderSpec,
    DateTimeTickFormatterSpec tickFormatterSpec,
    bool showAxisLine,
  }) : super(
            renderSpec: renderSpec,
            tickProviderSpec: tickProviderSpec,
            tickFormatterSpec: tickFormatterSpec,
            showAxisLine: showAxisLine);

  @override
  configure(Axis<DateTime> axis, ChartContext context,
      GraphicsFactory graphicsFactory) {
    super.configure(axis, context, graphicsFactory);
    axis.autoViewport = false;
  }
}