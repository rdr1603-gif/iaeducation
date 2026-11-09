-- =============================================================================
-- Articula Educación IA — seed de catálogo
-- ONIX Production
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. Permisos (con UUIDs)
-- -----------------------------------------------------------------------------
INSERT INTO public.permissions (id, key, description, category) VALUES
(gen_random_uuid(), 'platform.manage_institutions', 'Permite administrar sobre la plataforma.', 'Plataforma'),
(gen_random_uuid(), 'platform.manage_users', 'Permite administrar sobre la plataforma.', 'Plataforma'),
(gen_random_uuid(), 'platform.manage_subscriptions', 'Permite administrar sobre la plataforma.', 'Plataforma'),
(gen_random_uuid(), 'platform.view_stats', 'Permite ver sobre la plataforma.', 'Plataforma'),
(gen_random_uuid(), 'platform.view_audit', 'Permite ver sobre la plataforma.', 'Plataforma'),
(gen_random_uuid(), 'platform.manage_system', 'Permite administrar sobre la plataforma.', 'Plataforma'),
(gen_random_uuid(), 'institution.view', 'Permite ver sobre la institución.', 'Institución'),
(gen_random_uuid(), 'institution.update', 'Permite actualizar sobre la institución.', 'Institución'),
(gen_random_uuid(), 'institution.manage_members', 'Permite administrar sobre la institución.', 'Institución'),
(gen_random_uuid(), 'institution.manage_settings', 'Permite administrar sobre la institución.', 'Institución'),
(gen_random_uuid(), 'institution.purge_demo', 'Permite eliminar los datos de demostración sobre la institución.', 'Institución'),
(gen_random_uuid(), 'structure.view', 'Permite ver sobre la estructura académica.', 'Estructura académica'),
(gen_random_uuid(), 'structure.manage_cycles', 'Permite administrar sobre la estructura académica.', 'Estructura académica'),
(gen_random_uuid(), 'structure.manage_grades', 'Permite administrar sobre la estructura académica.', 'Estructura académica'),
(gen_random_uuid(), 'structure.manage_divisions', 'Permite administrar sobre la estructura académica.', 'Estructura académica'),
(gen_random_uuid(), 'structure.manage_areas', 'Permite administrar sobre la estructura académica.', 'Estructura académica'),
(gen_random_uuid(), 'structure.manage_school_years', 'Permite administrar sobre la estructura académica.', 'Estructura académica'),
(gen_random_uuid(), 'teacher.view', 'Permite ver sobre los docentes.', 'Docentes'),
(gen_random_uuid(), 'teacher.manage', 'Permite administrar sobre los docentes.', 'Docentes'),
(gen_random_uuid(), 'program.view_own', 'Permite ver sus propios registros sobre las planificaciones.', 'Planificaciones'),
(gen_random_uuid(), 'program.create', 'Permite crear sobre las planificaciones.', 'Planificaciones'),
(gen_random_uuid(), 'program.edit_own', 'Permite editar sus propios registros sobre las planificaciones.', 'Planificaciones'),
(gen_random_uuid(), 'program.delete_own', 'Permite eliminar sus propios registros sobre las planificaciones.', 'Planificaciones'),
(gen_random_uuid(), 'program.view_all', 'Permite ver todos los registros sobre las planificaciones.', 'Planificaciones'),
(gen_random_uuid(), 'program.edit_all', 'Permite editar cualquier registro sobre las planificaciones.', 'Planificaciones'),
(gen_random_uuid(), 'program.delete_all', 'Permite eliminar cualquier registro sobre las planificaciones.', 'Planificaciones'),
(gen_random_uuid(), 'program.share', 'Permite compartir sobre las planificaciones.', 'Planificaciones'),
(gen_random_uuid(), 'program.review', 'Permite revisar y aprobar sobre las planificaciones.', 'Planificaciones'),
(gen_random_uuid(), 'document.upload', 'Permite subir archivos sobre los documentos.', 'Documentos'),
(gen_random_uuid(), 'document.view_own', 'Permite ver sus propios registros sobre los documentos.', 'Documentos'),
(gen_random_uuid(), 'document.view_all', 'Permite ver todos los registros sobre los documentos.', 'Documentos'),
(gen_random_uuid(), 'document.delete_own', 'Permite eliminar sus propios registros sobre los documentos.', 'Documentos'),
(gen_random_uuid(), 'document.delete_all', 'Permite eliminar cualquier registro sobre los documentos.', 'Documentos'),
(gen_random_uuid(), 'ai.analyze_program', 'Permite analizar con IA sobre la inteligencia artificial.', 'Inteligencia artificial'),
(gen_random_uuid(), 'ai.generate_project', 'Permite generar sobre la inteligencia artificial.', 'Inteligencia artificial'),
(gen_random_uuid(), 'ai.generate_agenda', 'Permite generar sobre la inteligencia artificial.', 'Inteligencia artificial'),
(gen_random_uuid(), 'ai.assistant', 'Permite analizar con IA sobre la inteligencia artificial.', 'Inteligencia artificial'),
(gen_random_uuid(), 'ai.manage_config', 'Permite administrar sobre la inteligencia artificial.', 'Inteligencia artificial'),
(gen_random_uuid(), 'articulation.view', 'Permite ver sobre la articulación.', 'Articulación'),
(gen_random_uuid(), 'articulation.generate', 'Permite generar sobre la articulación.', 'Articulación'),
(gen_random_uuid(), 'articulation.review', 'Permite revisar y aprobar sobre la articulación.', 'Articulación'),
(gen_random_uuid(), 'articulation.manage', 'Permite administrar sobre la articulación.', 'Articulación'),
(gen_random_uuid(), 'curriculum_map.view', 'Permite ver sobre los mapas curriculares.', 'Articulación'),
(gen_random_uuid(), 'project.view', 'Permite ver sobre los proyectos.', 'Proyectos'),
(gen_random_uuid(), 'project.create', 'Permite crear sobre los proyectos.', 'Proyectos'),
(gen_random_uuid(), 'project.edit', 'Permite actualizar sobre los proyectos.', 'Proyectos'),
(gen_random_uuid(), 'project.delete', 'Permite eliminar sobre los proyectos.', 'Proyectos'),
(gen_random_uuid(), 'project.share', 'Permite compartir sobre los proyectos.', 'Proyectos'),
(gen_random_uuid(), 'project.manage', 'Permite administrar sobre los proyectos.', 'Proyectos'),
(gen_random_uuid(), 'meeting.view', 'Permite ver sobre las reuniones.', 'Reuniones'),
(gen_random_uuid(), 'meeting.create', 'Permite crear sobre las reuniones.', 'Reuniones'),
(gen_random_uuid(), 'meeting.edit', 'Permite actualizar sobre las reuniones.', 'Reuniones'),
(gen_random_uuid(), 'meeting.participate', 'Permite ver sobre las reuniones.', 'Reuniones'),
(gen_random_uuid(), 'meeting.manage', 'Permite administrar sobre las reuniones.', 'Reuniones'),
(gen_random_uuid(), 'meeting.export_minutes', 'Permite exportar sobre las reuniones.', 'Reuniones'),
(gen_random_uuid(), 'agreement.view_own', 'Permite ver sus propios registros sobre los acuerdos.', 'Acuerdos'),
(gen_random_uuid(), 'agreement.create', 'Permite crear sobre los acuerdos.', 'Acuerdos'),
(gen_random_uuid(), 'agreement.update_own', 'Permite actualizar sus propios registros sobre los acuerdos.', 'Acuerdos'),
(gen_random_uuid(), 'agreement.view_all', 'Permite ver todos los registros sobre los acuerdos.', 'Acuerdos'),
(gen_random_uuid(), 'agreement.update_all', 'Permite actualizar cualquier registro sobre los acuerdos.', 'Acuerdos'),
(gen_random_uuid(), 'report.generate_own', 'Permite generar sobre los informes.', 'Informes'),
(gen_random_uuid(), 'report.generate_all', 'Permite generar sobre los informes.', 'Informes'),
(gen_random_uuid(), 'report.view_all', 'Permite ver todos los registros sobre los informes.', 'Informes'),
(gen_random_uuid(), 'notification.view_own', 'Permite ver sus propios registros sobre las notificaciones.', 'Sistema'),
(gen_random_uuid(), 'notification.manage', 'Permite administrar sobre las notificaciones.', 'Sistema'),
(gen_random_uuid(), 'activity_log.view', 'Permite ver sobre la auditoría.', 'Sistema')
ON CONFLICT (key) DO UPDATE SET
  description = EXCLUDED.description,
  category = EXCLUDED.category;

-- -----------------------------------------------------------------------------
-- 2. Roles (con UUIDs)
-- -----------------------------------------------------------------------------
INSERT INTO public.roles (id, key, name, description, scope, is_system) VALUES
(gen_random_uuid(), 'SUPERADMIN', 'Superadministrador', 'Control global de ONIX Production: instituciones, usuarios, suscripciones, estadísticas, seguridad y configuración del sistema.', 'PLATFORM', true),
(gen_random_uuid(), 'ADMIN_INSTITUCIONAL', 'Administrador institucional', 'Administra la institución: usuarios, docentes, grados, divisiones, áreas, permisos y configuración.', 'INSTITUTION', true),
(gen_random_uuid(), 'DIRECTIVO', 'Directivo', 'Consulta planificaciones, articulaciones, proyectos, reuniones e informes de la institución.', 'INSTITUTION', true),
(gen_random_uuid(), 'COORDINADOR', 'Coordinador', 'Gestiona articulaciones, proyectos, reuniones, acuerdos y seguimiento pedagógico.', 'INSTITUTION', true),
(gen_random_uuid(), 'DOCENTE', 'Docente', 'Gestiona sus planificaciones y documentos, ejecuta análisis IA y participa de articulaciones, proyectos y reuniones autorizadas.', 'INSTITUTION', true)
ON CONFLICT (key) DO UPDATE SET
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  scope = EXCLUDED.scope,
  is_system = EXCLUDED.is_system;

-- -----------------------------------------------------------------------------
-- 3. Matriz rol -> permisos (sintaxis corregida)
-- -----------------------------------------------------------------------------
DO $$
DECLARE
  role_perms JSONB := jsonb_build_object(
    'DOCENTE', jsonb_build_array(
      'institution.view','structure.view','teacher.view',
      'program.view_own','program.create','program.edit_own','program.delete_own','program.share',
      'document.upload','document.view_own','document.delete_own',
      'ai.analyze_program','ai.generate_project','ai.assistant',
      'articulation.view','curriculum_map.view',
      'project.view','project.create','project.edit',
      'meeting.view','meeting.participate',
      'agreement.view_own','agreement.create','agreement.update_own',
      'report.generate_own','notification.view_own'
    ),
    'COORDINADOR', jsonb_build_array(
      'institution.view','structure.view','teacher.view',
      'program.view_own','program.create','program.edit_own','program.delete_own','program.share',
      'program.view_all','document.view_all',
      'ai.analyze_program','ai.generate_project','ai.generate_agenda','ai.assistant',
      'articulation.view','articulation.generate','articulation.review','articulation.manage',
      'curriculum_map.view',
      'project.view','project.create','project.edit','project.delete','project.share','project.manage',
      'meeting.view','meeting.create','meeting.edit','meeting.participate','meeting.manage','meeting.export_minutes',
      'agreement.view_own','agreement.create','agreement.update_own','agreement.view_all','agreement.update_all',
      'report.generate_own','report.generate_all','report.view_all',
      'notification.view_own','activity_log.view'
    ),
    'DIRECTIVO', jsonb_build_array(
      'institution.view','structure.view','teacher.view',
      'program.view_all','document.view_all',
      'ai.assistant',
      'articulation.view','curriculum_map.view',
      'project.view',
      'meeting.view','meeting.export_minutes',
      'agreement.view_all',
      'report.generate_all','report.view_all',
      'notification.view_own'
    ),
    'ADMIN_INSTITUCIONAL', jsonb_build_array(
      'institution.view','institution.update','institution.manage_members','institution.manage_settings','institution.purge_demo',
      'structure.view','structure.manage_cycles','structure.manage_grades','structure.manage_divisions','structure.manage_areas','structure.manage_school_years',
      'teacher.view','teacher.manage',
      'program.view_own','program.create','program.edit_own','program.delete_own','program.share','program.view_all','program.edit_all','program.delete_all','program.review',
      'document.upload','document.view_own','document.view_all','document.delete_own','document.delete_all',
      'ai.analyze_program','ai.generate_project','ai.generate_agenda','ai.assistant','ai.manage_config',
      'articulation.view','articulation.generate','articulation.review','articulation.manage',
      'curriculum_map.view',
      'project.view','project.create','project.edit','project.delete','project.share','project.manage',
      'meeting.view','meeting.create','meeting.edit','meeting.participate','meeting.manage','meeting.export_minutes',
      'agreement.view_own','agreement.create','agreement.update_own','agreement.view_all','agreement.update_all',
      'report.generate_own','report.generate_all','report.view_all',
      'notification.view_own','notification.manage','activity_log.view'
    ),
    'SUPERADMIN', (SELECT jsonb_agg(key) FROM public.permissions)
  );
  r text;
  perm_key text;
  role_id uuid;
  perm_id uuid;
BEGIN
  -- Limpiar y recrear matriz (idempotente)
  DELETE FROM public.role_permissions;

  FOR r IN SELECT jsonb_object_keys(role_perms)
  LOOP
    SELECT id INTO role_id FROM public.roles WHERE key = r;
    IF role_id IS NULL THEN CONTINUE; END IF;

    FOR perm_key IN SELECT jsonb_array_elements_text(role_perms->r)
    LOOP
      SELECT id INTO perm_id FROM public.permissions WHERE key = perm_key;
      IF perm_id IS NOT NULL THEN
        INSERT INTO public.role_permissions (role_id, permission_id)
        VALUES (role_id, perm_id)
        ON CONFLICT DO NOTHING;
      END IF;
    END LOOP;
  END LOOP;
END;
$$;

-- Verificación
SELECT r.key as rol, COUNT(rp.permission_id) as permisos
FROM public.roles r
LEFT JOIN public.role_permissions rp ON rp.role_id = r.id
GROUP BY r.key
ORDER BY CASE r.key
  WHEN 'SUPERADMIN' THEN 1
  WHEN 'ADMIN_INSTITUCIONAL' THEN 2
  WHEN 'COORDINADOR' THEN 3
  WHEN 'DIRECTIVO' THEN 4
  WHEN 'DOCENTE' THEN 5
END;