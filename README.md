# M. Akash Professional Site

Static site with Supabase-backed admin authentication, work entries, project data, profile settings, and service requests.

## Supabase setup

1. Open the Supabase SQL Editor for project `nhlkluccssdhmxmyobup`.
2. Run [`supabase/schema.sql`](supabase/schema.sql).
3. In Authentication → Users, create the admin email and password.
4. Deploy the site from the repository root with Netlify publish directory `.` and no build command.

The browser uses the public Supabase publishable key. Never place a service-role key in `dist/index.html`.
