export default function SomeoneWon(JAN) {}

export async function Test() {
    try {
        const response = await fetch(`/`, {
            method: 'GET',
            headers: {
                'Content-type': 'application/json'
            }
        });
        if (!response.ok) {
            throw new Error("Network error: Network response wasn't ok.");
        }
        return await response.text();
    } catch (error) {
        console.log("Error deleting the graph: ", error);
    }
}