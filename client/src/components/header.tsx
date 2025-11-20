export function Header() {
  return (
    <div className="text-center mb-12">
      <h1
        className="
          text-3xl md:text-5xl 
          font-bold mb-2 py-2
          bg-gradient-to-r from-purple-500 via-white to-blue-600 
          bg-clip-text text-transparent 
          leading-normal
        "
      >
        Celo Chess
      </h1>
      <p className="text-lg md:text-xl text-slate-300 max-w-2xl mx-auto px-4">
        Onchain chess game on{" "}
        <span className="text-transparent bg-clip-text bg-gradient-to-r from-purple-400 to-blue-400 font-semibold">
          Celo
        </span>{" "}
        blockchain
      </p>
    </div>
  );
}