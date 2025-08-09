"use client";

export default function GroupUsageTable({ groups }: { groups: Array<{ id: string; name: string; usageScore: number; type: string; members: string[]; events: string[] }> }) {
  return (
    <table className="min-w-full border mt-4">
      <thead>
        <tr>
          <th className="border px-2 py-1">Name</th>
          <th className="border px-2 py-1">Type</th>
          <th className="border px-2 py-1">Members</th>
          <th className="border px-2 py-1">Events</th>
          <th className="border px-2 py-1">Usage</th>
          <th className="border px-2 py-1">Alert</th>
        </tr>
      </thead>
      <tbody>
        {groups.map((g) => (
          <tr key={g.id}>
            <td className="border px-2 py-1">{g.name}</td>
            <td className="border px-2 py-1">{g.type}</td>
            <td className="border px-2 py-1">{g.members?.length || 0}</td>
            <td className="border px-2 py-1">{g.events?.length || 0}</td>
            <td className="border px-2 py-1">{g.usageScore}%</td>
            <td className="border px-2 py-1">{g.usageScore > 90 ? '⚠️ High' : ''}</td>
          </tr>
        ))}
      </tbody>
    </table>
  );
}



