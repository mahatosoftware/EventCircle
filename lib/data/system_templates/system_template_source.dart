import 'system_template_models.dart';

abstract class SystemTemplateSource {
  Future<SystemTemplatePack?> loadPack();
}

