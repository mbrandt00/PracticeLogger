import { LinearClient } from "npm:@linear/sdk";
import { createClient } from "jsr:@supabase/supabase-js@2";
import { IssueLabel } from "npm:@linear/sdk";

Deno.serve(async (req) => {
  try {
    if (req.method !== "POST") {
      return new Response("Method not allowed", { status: 405 });
    }

    const {
      title,
      description,
      issueType,
    }: { title: string; description: string; issueType: "bug" | "feature" } =
      await req.json();

    if (!title || !description) {
      return new Response("Missing required fields: title, description", {
        status: 400,
      });
    }
    const supabaseClient = createClient(
      // Supabase API URL - env var exported by default.
      Deno.env.get("SUPABASE_URL") ?? "",
      // Supabase API ANON KEY - env var exported by default.
      Deno.env.get("SUPABASE_ANON_KEY") ?? "",
      // Create client with Auth context of the user that called the function.
      // This way your row-level-security (RLS) policies are applied.
      {
        global: {
          headers: { Authorization: req.headers.get("Authorization")! },
        },
      },
    );
    const {
      data: { user },
    } = await supabaseClient.auth.getUser();

    const enhancedDescription = `${description}

---
**Reported by:** ${user?.email || "Unknown user"}
**User ID:** ${user?.id || "Unknown"} `;

    const apiKey = Deno.env.get("LINEAR_API_KEY");
    const teamId = Deno.env.get("LINEAR_TEAM_ID");
    if (!apiKey || !teamId) {
      throw "Missing key";
    }
    const client = new LinearClient({
      apiKey,
    });
    const issueLabels = await client.issueLabels();
    const issueTypeId = issueLabels.nodes.find(
      (node: IssueLabel) => node.name.toLowerCase() === issueType.toLowerCase(),
    )?.id;
    if (!issueTypeId) {
      throw "Missing issueType";
    }
    const linearResult = await client.createIssue({
      title,
      description: enhancedDescription,
      teamId,
      labelIds: [issueTypeId],
    });
    //

    if (!linearResult.success) {
      return new Response(
        JSON.stringify({ success: false, error: "Failed to create issue" }),
        {
          headers: { "Content-Type": "application/json" },
          status: 500,
        },
      );
    }

    return new Response(JSON.stringify({ success: true }), {
      headers: { "Content-Type": "application/json" },
    });
  } catch (err) {
    console.error("Error creating issue:", err);
    return new Response("Internal Server Error", { status: 500 });
  }
});
